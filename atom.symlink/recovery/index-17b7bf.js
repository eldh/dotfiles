import dotProp from 'dot-prop-immutable'
import PropTypes from 'prop-types'
import React, { createElement, Component } from 'react'
import createJsonValidator from '@dooer/json-validator'
import createJsonNormalizer from '@dooer/json-normalizer'

import generateForm from '../../lib/generate-form-from-schema'
import defaultFieldMetaState from '../../lib/default-field-meta-state'
import defaultFieldComponentResolver from './default-field-component-resolver'

const propTypes = {
  children: PropTypes.func,
  initialValues: PropTypes.object,
  onSubmit: PropTypes.func,
  onChange: PropTypes.func,
  component: PropTypes.any,
  fieldComponentResolver: PropTypes.func
}

const defaultProps = {
  fieldComponentResolver: defaultFieldComponentResolver,
  component: 'form'
}

const defaultState = {
  initialValues: {},
  formData: {},
  formMeta: {},
  formErrors: {},
  activeFieldName: ''
}

const getFieldMeta = ({ meta, value, initialValue }) => {
  if (!meta) return { ...defaultFieldMetaState, touched: true }

  return {
    ...meta,
    dirty: value !== initialValue,
    pristine: value === initialValue,
    touched: true
  }
}

const setFormDataValue = ({ formData, field, name, value, required }) => {
  const { type, items } = field

  if (value === null) return dotProp.delete(formData, name)

  const set = value => dotProp.set(formData, name, value)

  if (type !== 'array') return set(value)

  const currentValue = dotProp.get(formData, name)

  if (!currentValue) {
    return set([ value ])
  }

  if (items.enum && currentValue.includes(value)) {
    return set(currentValue.filter(v => v !== value))
  }

  return set([ ...currentValue, value ])
}

const validateForm = ({ normalizer, validator, formData }) => {
  const normalizedFormData = normalizer(formData)
  if (validator.isValid(normalizedFormData)) return {}

  return validator.errors.reduce((mem, error) => {
    const fieldName = error.field.replace(/^data\./, '')
    mem[fieldName] = error.message
    return mem
  }, {})
}

export default class Form extends Component {
  static propTypes = propTypes
  static defaultProps = defaultProps

  state = defaultState

  componentWillMount () {
    const { initialValues, schema } = this.props

    this.validator = createJsonValidator(schema)
    this.normalizer = createJsonNormalizer(schema)
    const formErrors = validateForm({ validator: this.validator, normalizer: this.normalizer, formData: initialValues || {} })
    if (initialValues) {
      this.setState({ formData: initialValues, initialValues, formErrors })
    } else {
      this.setState({ formErrors })
    }
  }

  handleFieldChange = (event, input, field) => {
    const { onChange } = this.props
    const { name, required } = input

    const isEventEvent = event && typeof event === 'object' && event.target
    const value = isEventEvent ? event.target.value : event

    const formData = setFormDataValue({ formData: this.state.formData, name, field, value, required })

    const formErrors = validateForm({ validator: this.validator, normalizer: this.normalizer, formData })
    console.log(formErrors, 'sdsdsd')

    const formMeta = dotProp.set(this.state.formMeta, name, getFieldMeta({
      meta: dotProp.get(this.state.formMeta, name),
      value,
      initialValue: dotProp.get(this.state.initialValues, name)
    }))

    this.setState({
      formData,
      formMeta,
      formErrors
    })

    const normalizedFormData = this.normalizer(formData)

    if (onChange) {
      return onChange({
        event: isEventEvent ? event : null,
        formData: normalizedFormData,
        previousFormData: this.state.formData,
        formMeta,
        previousFormMeta: this.state.formMeta,
        value
      })
    }
  }

  handleFieldFocus = (event, input) => {
    const { name } = input

    this.setState({ activeFieldName: name })
  }

  handleFieldBlur = () => {
    this.setState({ activeFieldName: null })
  }

  handleSubmit = (event) => {
    event.preventDefault()

    const { onSubmit } = this.props
    const normalizedFormData = this.normalizer(this.state.formData)
    if (onSubmit) return onSubmit({ event, formData: normalizedFormData })
  }

  render () {
    const { children, component, fieldComponentResolver, onSubmit, schema, ...additional } = this.props
    const { formData, formMeta, formErrors, activeFieldName } = this.state

    const fieldHandlers = {
      onChange: this.handleFieldChange,
      onFocus: this.handleFieldFocus,
      onBlur: this.handleFieldBlur
    }

    const fields = generateForm({
      schema,
      componentResolver: fieldComponentResolver,
      fieldHandlers,
      formData,
      formMeta,
      formErrors,
      activeFieldName
    })

    const controls = children || (onSubmit && (
      <div>
        <button type='submit'>[fallback submit string]</button>
      </div>
    ))

    return createElement(component, {
      ...additional,
      onSubmit: this.handleSubmit
    }, fields, controls)
  }
}
