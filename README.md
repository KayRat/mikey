# mikey
**mikey** was built because I have always been unhappy with the available selection of administration mods available in Garry's Mod. None were built with the features and exposed APIs I desired and the amount of work needed to acquire those exceeded the amount needed to build what I wanted from scratch.

There were a few driving forces behind several design choices in this modification. The big ones were other administration tools not playing nice when run across multiple servers, data falling out of sync, ranks not being synced with websites/forums (why do people continue to duplicate their work by assigning web ranks separate from game ranks???), and not having the desired API access for certain features.

I did originally want all read/write operations to be done via API calls to a node.js server that would spit out JSON responses, but the HTTP libraries exposed to the Lua API in Garry's Mod are too slow and unreliable to build an entire modification around them. In my experience they tend to block the server and sometimes fail with error reason *unsuccessful* (that's helpful!) or just vanish altogether. 

This mod is named after Michael Scott, the television character from The Office, which is my favorite TV show. I have left a few references to the show throughout the modification.

## Setting up the database
Below is the template for the MySQL configuration file, which should be filled out and stored in **data/mikey_config.json**. **Note that it is a .json** file, not .txt. Also make sure that **mysqloo** is installed, as this mod relies on it (no tmysql4 won't work).

````json
{
  "hostname"  : "",
  "username"  : "",
  "password"  : "",
  "database"  : "",
  "port"      : 3306
}
````
