import { graphql } from 'graphql'
import schema from './schema'

export const handler = (event, context, callback) => {
  context.callbackWaitsForEmptyEventLoop = false
  console.log('event:', event)

  if (event.httpMethod == 'OPTIONS') {
    callback(null, {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Authorization, Content-Type',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, PATCH',
        'Access-Control-Allow-Credentials': 'true',
        'Content-Type': 'application/json',
      },
      body: null,
    })
  } else {
    const { query, variables, operationName } = JSON.parse(event.body)
    const rootValue = {}
    const ctx = {}
    graphql(schema, query, rootValue, ctx, variables, operationName)
      .then(d => {
        callback(null, {
          statusCode: 200,
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': 'Authorization, Content-Type',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, PATCH',
            'Access-Control-Allow-Credentials': 'true',
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(d),
        })
      })
      .catch(e => {
        callback(null, {
          statusCode: 503,
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': 'Authorization, Content-Type',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, PATCH',
            'Access-Control-Allow-Credentials': 'true',
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(e),
        })
      })
  }
}
