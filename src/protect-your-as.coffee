http = require 'http'
class ProtectYourAs
  constructor: () ->

  do: (job, callback) =>
    authUuid = job.metadata.auth.uuid
    {toUuid, fromUuid, responseId} = job.metadata

    return @sendResponse responseId, 204, callback unless fromUuid?
    return @sendResponse responseId, 204, callback if fromUuid == authUuid
    return @sendResponse responseId, 204, callback unless fromUuid == toUuid

    @sendResponse responseId, 403, callback

  sendResponse: (responseId, code, callback) =>
    callback null,
      metadata:
        responseId: responseId
        code: code
        status: http.STATUS_CODES[code]

module.exports = ProtectYourAs
