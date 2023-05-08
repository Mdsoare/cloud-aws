"use strict";
const { v4 } = require("uuid");
const AWS = require("aws-sdk");

const dynamodb = new AWS.DynamoDB.DocumentClient();

module.exports.handler = async (event) => {
  try {
    const { item } = JSON.parse(event.body);
    const createdAt = new Date().toISOString();
    const id = v4();

    const newItem = {
      id,
      item,
      createdAt,
      itemStatus: false,
    };

    await dynamodb.put({
      TableName: "ItemTable",
      Item: newItem,
    }).promise();

    return {
      statusCode: 200,
      body: JSON.stringify(newItem),
    };
  } catch (error) {
    console.log(error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "An error occurred",
      }),
    };
  }
};