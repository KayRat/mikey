# mikey
This modification exists because I was unhappy with the other admin tool options available.

There were a few driving forces behind several design of this modification:
* Most admin mods don't natively support using a database (which sucks for syncing between servers)
* No sync between your website and game permissions
* Not enough API exposed to create plugins

I did originally want all read/write operations to be done via API calls to a node.js server that would spit out JSON responses, but the HTTP libraries exposed to the Lua API in Garry's Mod are too slow and unreliable to build an entire modification around them. In my experience they tend to block the server and sometimes fail with error reason *unsuccessful* (that's helpful!) or just vanish altogether. 

This mod is named after Michael Scott, the television character from The Office, which is my favorite TV show. I have left a few references to the show throughout the modification.

## Dependencies
* [gmsv_mysqloo v9](https://facepunch.com/showthread.php?t=1515853) by [syl0r](https://facepunch.com/member.php?u=475644)

## Configuring MySQL
The MySQL connection is configured from **data/mikey_config.json**. The first time mikey is started, it should create the necessary database structure.

### data/mikey_config.json

````json
{
  "hostname"  : "",
  "username"  : "",
  "password"  : "",
  "database"  : "",
  "port"      : 3306
}
````
