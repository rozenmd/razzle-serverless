import { makeExecutableSchema } from 'graphql-tools'
import typeDefs from './schema.graphql'
import resolvers from './resolvers'

export default makeExecutableSchema({
  typeDefs,
  resolvers,
})
