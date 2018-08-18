import cors from 'cors'
import express from 'express'
import schema from './schema'
import { json } from 'body-parser'
import { graphql } from 'graphql'

const PORT = process.env.PORT || 3002

const app = express()

app.use(cors())

app.post('/graphql', json(), (req, res) => {
  const { query, variables } = req.body
  const rootValue = {}
  const context = {}
  let operationName
  console.log('query: ', query)
  console.log('variables: ', variables)
  graphql(schema, query, rootValue, context, variables, operationName)
    .then(d => {
      console.log('d: ', d)
      res
        .status(200)
        .set('Content-Type', 'application/json')
        .send(JSON.stringify(d))
    })
    .catch(e => {
      console.log('e: ', e)
      res
        .status(500)
        .set('Content-Type', 'application/json')
        .send(JSON.stringify(e))
    })
})

app.listen(PORT, err => {
  if (err) {
    throw err
  }
  console.log(`Listening on http://localhost:${PORT}/`)
})
