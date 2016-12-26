(function () {
  angular.module('gradepal.main.controllers').controller('CoursesCtrl', CoursesCtrl);

  CoursesCtrl.$inject = ['$scope', '$routeParams', '$location', '$http', '$resource', '$filter', 'flash'];

  function CoursesCtrl($scope, $routeParams, $location, $http, $resource, $filter, flash) {
    var ctrl = this;

    ctrl.init = function () {
      ctrl.updateList();
    }

    ctrl.search = function (keywords) {
      console.log(keywords);
      var course = ctrl.courses.find((course) => course.code === keywords.split(' -')[0]);
      if (course){
        ctrl.setActiveCourse(course);
      }
      // $location.path('/').search('keywords', keywords);
    }

    ctrl.updateList = function () {
      $http.get('/courses', {params: {format:'json'}}).then(function(results) {
        ctrl.courses = results.data.sort(function (a,b) {
          return a.id - b.id;
        });
        ctrl.activeCourse = ctrl.courses[0];
      });
      // ctrl.addingCourse = false;
    }

    ctrl.showNewCourse = function () {
      console.log('add');
      ctrl.addingCourse = true; // view will show the appropriate box
    }

    ctrl.setActiveCourse = function (course) {
      ctrl.activeCourse = course;
      $scope.keywords = course.code + ' - ' + course.name;
      console.log('Set active course to '+course.code+' - '+course.name);
    }

    // view, edit, and delete functions are in course-card directive now
    ctrl.init();
  }
})();
