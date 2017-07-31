import React from 'react'
import PropTypes from 'prop-types'
import Radium from 'radium'

import { Flex } from '@dooer/fe-ui-kit'

const FlexDataTable = ({ rows, RowComponent = Row, rowKey = ({ key }) => key, columns, style, ...rest }) => (
  <Flex style={style} {...rest}>
    {rows.map(
      (row, i) =>
        row ? (
          <RowComponent flexDirection="row" key={rowKey(row)} last={i + 1 === rows.length}>
            {columns.map((column, i) => column(row, i))}
          </RowComponent>
        ) : null
    )}
  </Flex>
)

FlexDataTable.propTypes = {
  RowComponent: PropTypes.node,
  rowKey: PropTypes.string,
  rows: PropTypes.arrayOf(PropTypes.object).isRequired,
  columns: PropTypes.arrayOf(PropTypes.func).isRequired,
}

FlexDataTable.Cell = Radium(function FlexTableCell({ children, style, ...rest }) {
  return (
    <Flex alignItems="center" row style={{ padding: '10px', ...style }} {...rest}>
      {children}
    </Flex>
  )
})

const Row = Radium(function FlexTableRow({ children, last }) {
  return (
    <Flex row style={last ? null : { borderBottom: '1px #e3e3e3 solid' }}>
      {children}
    </Flex>
  )
})

export default Radium(FlexDataTable)
