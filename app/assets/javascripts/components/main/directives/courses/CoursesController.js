(function () {
  angular.module('gradepal.main.controllers').controller('CoursesCtrl', CoursesCtrl);

  CoursesCtrl.$inject = ['$scope', '$routeParams', '$location', '$resource', '$filter', 'flash'];

  function CoursesCtrl($scope, $routeParams, $location, $resource, $filter, flash) {
    var Course = $resource('/courses/:courseId', {courseId: '@id', format: 'json' },
      {
        'delete': {method: 'DELETE'},
        'create': {method: 'POST'},
        'save': {method: 'PUT'}
      });

    var ctrl = this;

    /**
     * Initial function. Update the course list
     */
    ctrl.init = function () {
      ctrl.updateList();
    }

    ctrl.search = function (keywords) {
      $location.path('/').search('keywords', keywords);
    }

    ctrl.updateList = function () {
      if ($routeParams.keywords) {
        Course.query({keywords: $routeParams.keywords}, function (results) {ctrl.courses = results;});
      }
      else {
        Course.query(function (results) {
          ctrl.courses = results;
        });
      }
      // ctrl.addingCourse = false;
    }

    ctrl.showNewCourse = function () {
      ctrl.addingCourse = true; // view will show the appropriate box
    }

    // view, edit, and delete functions are in course-card directive now
    ctrl.init();
  }
})();
