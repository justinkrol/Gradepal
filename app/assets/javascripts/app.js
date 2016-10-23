(function (){
  gradepal = angular.module('gradepal',[
    // components
    'gradepal.main',

    // angular
    'templates',
    'ngRoute',
    'ngResource',
    'controllers',
    'angular-flash.service',
    'angular-flash.flash-alert-directive'
  ]);

  gradepal.config([ '$routeProvider', 'flashProvider',
    function ($routeProvider, flashProvider) {
      // flashProvider.setTimeout(5000);
      // flashProvider.setShowClose(true);
      flashProvider.errorClassnames.push('alert-danger');
      flashProvider.warnClassnames.push("alert-warning");
      flashProvider.infoClassnames.push("alert-info");
      flashProvider.successClassnames.push("alert-success");

      $routeProvider.when('/',
        {
          templateUrl: 'index.html',
          controller: 'CoursesCtrl'
        });
    }
  ]);
  controllers = angular.module('controllers',[]);
})();
