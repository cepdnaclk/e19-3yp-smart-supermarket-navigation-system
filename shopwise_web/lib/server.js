const express = require("express");
const MongoClient = require("mongodb").MongoClient;
const bodyParser = require("body-parser");

const app = express();
app.use(bodyParser.json());

const uri =
  "mongodb+srv://e19409:nzwT0TH9whD6I5Cz@cluster0.cdcjteb.mongodb.net/shoppinglist?retryWrites=true&w=majority";
const client = new MongoClient(uri, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

app.get("/data", async (req, res) => {
  const collection = client.db("test").collection("devices");
  const data = await collection.find({}).toArray();
  res.json(data);
});

app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
