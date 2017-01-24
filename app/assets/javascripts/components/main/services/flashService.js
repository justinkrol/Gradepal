(function () {
  angular.module('gradepal').service('flashService', flashService);

  flashService.$inject = ['flash'];

  function flashService(flash) {

    var STREAMS = {
      error: 'error',
      success: 'success',
      warning: 'warning',
      info: 'info'
    }

    var clearStreams = function() {
      for (stream in STREAMS) {
        flash[stream] = '';
      }
    }

    this.message = function(stream = STREAMS.info, message){
      clearStreams();
      flash[stream] = message;
    }

    this.errors = function (errors) {
      this.message(STREAMS.error, errors.join(', '));
    }
  }
})();
