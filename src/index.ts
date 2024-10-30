import Fastify from 'fastify'
import { GitHubRepoTreeResponse } from './types'

console.log('start script')

const server = Fastify({
  logger: true,
})

// Declare a route

server.get('/', async (request, reply) => {
  // https://api.github.com/repos/otmjka/log-content/git/trees/main?recursive=1

  const url =
    'https://api.github.com/repos/otmjka/log-content/git/trees/main?recursive=1'
  const response = await fetch(url)
  const data = (await response.json()) as GitHubRepoTreeResponse

  const mdFiles = data.tree.filter((item) => /\.md$/.test(item.path))

  const mdFileNames = mdFiles.map(({ path, url }) => ({
    path,
    url,
  }))
  return { articles: mdFileNames }
})

server.get('/ping', async (request, reply) => {
  return 'pong'
})

// Run the Server!
const start = async () => {
  try {
    server.listen({ port: 3000, host: '0.0.0.0' }, (err) => {
      if (err) throw err
      console.log('Server listening on port 3000')
    })
  } catch (err) {
    server.log.error('!', err)
    process.exit(1)
  }
}
start()
