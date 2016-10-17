(function () {
  angular.module('gradepal.main.directives')
    .directive('gpCourseCard', function () {
      return {
        restrict: 'E',
        templateUrl: 'components/main/directives/course-card/course-card-view.html',
        scope: {
          gpCourseId: '=',
          gpEditing: '='
        },
        link: function () {

        },
        controller: 'CourseCardCtrl',
        controllerAs: 'ctrl'
      }
    });
})();
