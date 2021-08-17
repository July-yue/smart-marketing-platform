const fs = require('fs');
const http = require('http');

const dirName = __dirname;

http.createServer(function (req, res) {
    if (/^\/static/.test(req.url)) {
        const resource = fs.readFileSync(`${dirName}${req.url}`);
        res.end(resource);
        return
    }
    const html = fs.readFileSync(`${dirName}/index.html`);
    res.setHeader('Content-Type','text/html;charset=utf-8');
    res.end(html);
}).listen(3000);

console.log('Server running at http://127.0.0.1:3000/');
