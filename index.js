// index.js
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const dotenv = require('dotenv');

const arweave = require('arweave');
const deso = require('deso');

dotenv.config();

const app = express();

app.use(bodyParser.json());
app.use(cors());

app.post('/upload', async (req, res) => {
  const data = req.body.data;

  const arweaveClient = new arweave.Arweave({
    host: 'arweave.net',
    port: 443,
    protocol: 'https'
  });

  const transaction = await arweaveClient.createTransaction({
    data
  });

  const id = transaction.id;

  res.json({ id });
});

app.post('/post', async (req, res) => {
  const body = req.body.body;

  const post = await deso.post(body);

  res.json(post);
});

app.get('/posts/:username', async (req, res) => {
  const username = req.params.username;

  const posts = await deso.get_user_posts(username);

  res.json(posts);
});

app.listen(3000, () => {
  console.log('Server listening on port 3000');
});
