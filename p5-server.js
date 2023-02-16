/*
  REST API/CRUD HTTP Verb and Status Codes
  CRUD    Verb    Entire Collection   Single Item
  ------------------------------------------------------------------------
  Default for bad URLs                404 (Not Found - Bad URL)
  Default for errors                  400 (Bad Request)
  Create  POST    405 (Not Allowed)   201 (Created)
                                      409 (Conflict - already exists)
  Read    GET     200 (OK)            200 (OK - content found)
                                      204 (No Content - can't find content)
  Update  PUT     405 (Not Allowed)   204 (OK - content updated)
                                      204 (No Content - can't find content)
  Delete  DELETE  405 (Not Allowed)   200 (OK - content deleted)
                                      204 (No Content - can't find content)
*/

// #region  **** Libraries ****
// Require filesystem library
const fs = require("fs");

// Require mysql connection library
const mysql = require("mysql2");

// Require the Fastify framework and instantiate it
const fastify = require("fastify")();
// #endregion

// #region  **** Connection information ****
// Include server access information
const dbInfo = require("./dbInfo.js");
// #endregion
// #region **** Use non-object or object version of SQL parameterization ****
// Toggle between using object method for queries
const ObjectQueriesToggle = false;
// #endregion

// #region  **** Console output settings ****
// Debug toggle: output debug statements to console
const DO_DEBUG = true;

// Status toggle: output status messages to console
const DO_STATUS = true;
// #endregion

// #region **** Web Page
// Handle "/" GET route

// #region  **** Read/GET (CRUD/HTTP verb) ****
// Read/GET: Get blog_entries
fastify.get("/blog_entries/:entry_id?", (request, reply) => {
  // Extract entry_id from request object using deconstruction
  const { entry_id = "" } = request.params;
  if (DO_DEBUG) console.log("Route /blog_entries GET", entry_id);

  // Initialize data object for query
  let data = [];

  // Define initial query (embedded query)
  let sql = "SELECT * FROM blog_entries";

  // Construct query using ? as replacement parameters replaced from data
  if (entry_id.length > 0) {
    if (!ObjectQueriesToggle) {
      // Non-object technique
      sql += " WHERE entry_id = ?";
      data.push(entry_id);
    } else {
      // Object technique, only works if request parameter(s) match database column names
      sql += " WHERE ?";
      data = request.params;
    }
    if (DO_DEBUG) console.log(data);
  } else {
    sql += " ORDER BY author_first_name";
  }
  if (DO_DEBUG) console.log("SQL", sql);

  // Setup default response object
  const response = {
    error: "",
    statusCode: 200,
    rows: [],
  };

  // Execute query and respond
  connection.query(sql, data, (errQuery, rows) => {
    if (errQuery) {
      if (DO_STATUS) console.log(errQuery);
      response.error = errQuery;
      response.statusCode = 400;
    } else if (rows.length > 0) {
      if (DO_STATUS) console.log("Rows returned", rows.length);
      response.rows = rows;
    } else {
      if (DO_STATUS) console.log("No blog rows...\n");
      response.statusCode = 204;
    }

    // Webserver response
    reply
      .code(response.statusCode)
      .header("Content-Type", "application/json; charset=utf-8")
      .send(response)
      .send(response);
  });
});
// #endregion

// #region **** Create/POST (CRUD/HTTP verb) ****
// Create/POST: Add color
// Note: The trailing / (e.g. /colors/) is required to make POST work
fastify.post("/blog_entries/", (request, reply) => {
  // Create renamed local variables from request body object color and hex properties
  const { entry: entry_id, blog: blog_id } = request.body;
  if (DO_DEBUG) console.log("Route /blog_entries POST", entry_id, blog_id);

  // Define initial query (embedded query), and data object
  let sql = "INSERT INTO BLOG_ENTRIES SET entry_id = ?, blog_id = ?";
  let data = [entry_id, blog_id];
  if (ObjectQueriesToggle) {
    sql = "INSERT INTO blog_entries SET ?";
    data = { entry_id, blog_id };
  }

  // Setup default response object
  const response = {
    error: "",
    statusCode: 201,
    id: "",
  };

  // Execute query and respond
  connection.query(sql, data, (errQuery, result) => {
    if (errQuery) {
      if (DO_STATUS) console.log(errQuery);
      response.error = errQuery;
      response.statusCode = 400;
    } else {
      if (DO_STATUS) console.log("Insert ID: ", result.insertId);
      response.id = result.insertId;
    }

    // Webserver response
    reply
      .code(response.statusCode)
      .header("Content-Type", "application/json; charset=utf-8")
      .send(response);
  });
});

// #region **** Delete/DELETE (CRUD/HTTP verb) ****
// Delete/DELETE: Delete blog_entries

fastify.delete("/deleteblog", (request, reply) => {
  try {
    const result = request
      .body()
      .input("entryID", request.body)
      .execute("sp_delete_blog");
    console.log("blog deleted");
  } catch (err) {
    reply.status(500).json(err);
  }
});

// #region **** Update/PUT: Update blog_entries ****
fastify.put("/blog_entries/:entry_id?", (request, reply) => {
  // Extract entry_id from request object using deconstruction
  const { entry_id = "" } = request.params;
  const { first: author_first_name, last: author_last_name } = request.body;
  if (DO_DEBUG)
    console.log(
      "Route /blog_entries PUT",
      entry_id,
      author_first_name,
      author_last_name
    );

  // Define initial query (embedded query), and data object
  let sql = "UPDATE blog_entries SET ";
  let setSQL = "";
  let data = [];
  if (!ObjectQueriesToggle) {
    if (author_first_name) {
      setSQL = "authour_first_name = ?";
      data.push(author_first_name);
    }
    if (author_last_name) {
      if (setSQL.length > 0) {
        setSQL += ", ";
      }
      setSQL += "author_last_name = ?";
      data.push(author_last_name);
    }
    if (setSQL.length > 0 && entry_id.length > 0) {
      setSQL += " WHERE entry_id = ?";
      data.push(entry_id);
    }
  } else {
    // Object version
    sql = "UPDATE blog_entries SET ? WHERE entry_id=?";
    data = { entry_id };
  }

  // Setup default response object
  const response = {
    error: "",
    statusCode: 201,
    id: "",
  };

  // Execute query and respond
  if (entry_id.length > 0) {
    // Verify sql and data populated for update
    if (setSQL.length === 0 || data.length === 0) {
      // Webserver response
      response.statusCode = 400;
      response.error = "Data missing for update";
      reply
        .code(response.statusCode)
        .header("Content-Type", "application/json; charset=utf-8")
        .send(response);
    } else {
      // Delete single item
      sql += setSQL;
      connection.query(sql, data, (errQuery, result) => {
        if (errQuery) {
          if (DO_STATUS) console.log(errQuery);
          response.error = errQuery;
          response.statusCode = 400;
        } else {
          const { affectedRows = 0 } = result;
          if (affectedRows > 0) {
            if (DO_STATUS) console.log("Update ID: ", entry_id);
            response.id = entry_id;
          } else {
            if (DO_STATUS) console.log("Unknown ID: ", entry_id);
            response.statusCode = 404;
          }
        }
        // if (DO_DEBUG) console.log(result);

        // Webserver response
        reply
          .code(response.statusCode)
          .header("Content-Type", "application/json; charset=utf-8")
          .send(response);
      });
    }
  } else {
    // Attempt to delete collection not supported
    // Webserver response
    response.statusCode = 405;
    response.error = "Delete entire collection not allowed";
    reply
      .code(response.statusCode)
      .header("Content-Type", "application/json; charset=utf-8")
      .send(response);
  }
});
// #endregion

// #region **** Ummatched routes ****
// Unmatched route handler
function unmatchedRouteHandler(reply) {
  // Setup default response object
  const response = {
    error: "Unsupported request",
    statusCode: 404,
  };
  reply
    .code(response.statusCode)
    .header("Content-Type", "application/json; charset=utf-8")
    .send(response);
}

// Unmatched verbs
fastify.get("*", (_, reply) => {
  unmatchedRouteHandler(reply);
});
fastify.post("*", (_, reply) => {
  unmatchedRouteHandler(reply);
});
fastify.delete("*", (_, reply) => {
  unmatchedRouteHandler(reply);
});
fastify.put("*", (_, reply) => {
  unmatchedRouteHandler(reply);
});
// #endregion

// #region **** Create database connection ****
// Note: Output all of the DB connection statements
console.log("Creating connection...\n");
let connection = mysql.createConnection({
  host: dbInfo.dbHost,
  port: dbInfo.dbPort,
  user: dbInfo.dbUser,
  password: dbInfo.dbPassword,
  database: dbInfo.dbDatabase,
});
// Connect to database
connection.connect(function (err) {
  console.log("Connecting to database...\n");

  if (err) {
    // Handle any errors
    console.log(err);
    console.log("Exiting application...\n");
  } else {
    console.log("Connected to database...\n");
    // Start server and listen to requests using Fastify
    // Note: Latest version of fastify listen requires object as first parameter
    const host = "127.0.0.1";
    const port = 8080;
    fastify.listen({ host, port }, (err, address) => {
      if (err) {
        console.log(err);
        process.exit(1);
      }
      console.log(`Server listening on ${address}`);
    });
  }
});
// #endregion
