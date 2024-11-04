const { createServer } = require('http')
const next = require('next')

const dev = false
const port = 3000
const hostname = 'localhost'
const app = next({ dev, hostname, port })
const handle = app.getRequestHandler()

app.prepare().then(() => {
  const server = createServer((req, res) => {
    handle(req, res)
  })

  server.listen(port, (err) => {
    if (err) throw err
    console.log(`Server is running on http://${hostname}:${port}`)
  })

  // Graceful shutdown
  process.on('SIGINT', () => {
    console.log('SIGINT signal received: closing HTTP server')
    server.close(() => {
      console.log('HTTP server closed')
      process.exit(0)
    })
  })

  process.on('SIGTERM', () => {
    console.log('SIGTERM signal received: closing HTTP server')
    server.close(() => {
      console.log('HTTP server closed')
      process.exit(0)
    })
  })
})
