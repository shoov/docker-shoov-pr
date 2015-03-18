var Promise = require("bluebird");
var yaml = require('js-yaml');
var fs = Promise.promisifyAll(require("fs"));
var R = require('ramda');

var prepareShFile = function(json) {
  var contents = [
    'cp ~/data/id_rsa ~/.ssh/id_rsa',
    'cd ~/build',
    'git clone git@github.com:amitaibu/gizra-behat.git .',
    'set -x'
  ];

  contents = contents.concat(json.before_script);
  contents = contents.concat(json.script);

  return contents.join('\n');
}

fs.readFileAsync('/home/behat/build/.shuv.yml')
  .then(function (data) {
    return yaml.safeLoad(data);
  })
  .then(function (json) {
    return fs.writeFileAsync('/home/behat/shuv.sh', prepareShFile(json));
  })
  .then(function() {
    return fs.chmodAsync('/home/behat/shuv.sh', '777')
  })
  .catch(SyntaxError, function (e) {
    console.error("file contains invalid json");
  }).catch(Promise.OperationalError, function (e) {
    console.error(e.message);
  });
