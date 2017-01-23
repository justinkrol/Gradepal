(function () {
  angular.module('gradepal').service('flashService', flashService);

  flashService.$inject = ['flash'];

  function flashService(flash) {
      this.showErrors = function (errors) {
        flash.error = errors.join(', ');
      }
  }
})();
