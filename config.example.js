// Mix of official config.example.js and
// https://adrianperez.org/advanced-deployment-of-ghost-in-2-minutes-with-docker/

var path = require('path'),
    config;

function getDatabaseConfig() {
  var db_config = {};

  switch (process.env.DB_CLIENT) {
    default:
      db_config = {
          client: 'sqlite3',
          connection: {
            filename: path.join(process.env.GHOST_CONTENT, (process.env.NODE_ENV == 'production') ? '/data/ghost.db' : '/data/ghost-dev.db')
          },
          debug: false
      };

      break;
  }


  return db_config;
}

function getMailConfig() {
  var mail_config = {};

  // Visit http://support.ghost.org/mail for instructions
  if (process.env.MAIL_TRANSPORT) { mail_config['transport']          = process.env.MAIL_TRANSPORT }
  if (process.env.MAIL_FROM)      { mail_config['from']               = process.env.MAIL_FROM }
  if (process.env.MAIL_HOST)      { mail_config['options']['host']    = process.env.MAIL_HOST }
  if (process.env.MAIL_PORT)      { mail_config['options']['port']    = process.env.MAIL_PORT }
  if (process.env.MAIL_SERVICE)   { mail_config['options']['service'] = process.env.MAIL_SERVICE }
  if (process.env.MAIL_USER) { mail_config['options']['auth']['user'] = process.env.MAIL_USER }
  if (process.env.MAIL_PASS) { mail_config['options']['auth']['pass'] = process.env.MAIL_PASS }

  return mail_config;
}

if (!process.env.URL) {
  console.log("Please set URL environment variable to your blog's URL");
  process.exit(1);
}

function getEnvConfig() {
  var env_config = {
      url: process.env.URL,
      mail: getMailConfig(),
      database: getDatabaseConfig(),
      server: {
          host: '0.0.0.0',
          port: '2368'
      },
      paths: {
          contentPath: path.join(process.env.GHOST_CONTENT, '/')
      }
  };

  return env_config;
}

config = {
    production: getEnvConfig(),
    development: getEnvConfig()
};

module.exports = config;
