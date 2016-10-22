(function () {
  angular.module('gradepal.main.directives')
   .directive('gpCourses', function () {
     return {
       restrict: 'E',
       templateUrl: 'components/main/directives/courses/courses-view.html',
       scope: {},
       link: function () {},
       controller: 'CoursesCtrl',
       controllerAs: 'ctrl'
     }
   });
})();
