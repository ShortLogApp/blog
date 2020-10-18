process.env["storage__active"] = "ghost-storage-github";
process.env["storage__ghost-storage-github__token"] = process.env.GITHUB_TOKEN;
process.env["storage__ghost-storage-github__repo"] = process.env.GITHUB_REPO;
process.env["storage__ghost-storage-github__branch"] =
  process.env.GITHUB_BRANCH;
process.env["storage__ghost-storage-github__destination"] =
  process.env.GITHUB_DESTINATION;
process.env["storage__ghost-storage-github__baseUrl"] =
  process.env.GITHUB_BASEURL;
process.env["storage__ghost-storage-github__useRelativeUrls"] =
  process.env.GITHUB_USERELATIVEURLS;

require("./index.js");
