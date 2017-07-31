import React from 'react'
import cn from 'classnames'
import url from 'url'

import { view, Link } from '@dooer/frontend'

import MessageQuestionForm from './message-question-form'
import MessageFreeForm from './message-free-form'
import { sendCustomerQuestion, sendCustomerFreeText } from '../mutations'

class MessageForm extends React.Component {
  render () {
    const { params, query } = this.props
    function getLink ({type = query.type, organizationId = params.organizationId, entityId = params.entityId, tab = query.tab} = {}) {
      return url.format({
        pathname: `/organizations/${organizationId}/${entityId || ''}`,
        query: { type: type || 'document', tab: tab || 'question' }
      })
    }

    return (
      <div className='mt-4 pt-4 pb-4'>
        <h4>New question</h4>
        <ul className='nav nav-tabs'>
          <li className='nav-item'>
            <Link
              className={cn('nav-link', { 'active': this.props.query.tab !== 'freetext' })}
              href={getLink({tab: 'question'})}
            >
              Select Question Template
            </Link>
          </li>
          <li className='nav-item'>
            <Link
              className={cn('nav-link', { 'active': this.props.query.tab === 'freetext' })}
              href={getLink({tab: 'freetext'})}
            >
              Write Your Own Question
            </Link>
          </li>
        </ul>
        {this.props.query.tab === 'freetext'
          ? <MessageFreeForm {...this.props} getLink={getLink} />
          : <MessageQuestionForm {...this.props} getLink={getLink} />
        }
      </div>
    )
  }
}

export default view(MessageForm, {
  mutations: {
    sendCustomerQuestion,
    sendCustomerFreeText
  }
})
