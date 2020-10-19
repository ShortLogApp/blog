process.env["server__port"] = process.env.PORT || 8080;
process.env["storage__active"] = "gcs";
process.env["storage__gcs__bucket"] = process.env.GCS_BUCKET;

require("./origIndex.js");
