(function () {
  angular.module('gradepal.main.directives')
    .directive('gpCourseCard', function ($compile) {
      return {
        restrict: 'E',
        templateUrl: 'components/main/directives/course-card/course-card-view.html',
        scope: {
          gpCourse: '=',
          gpEditing: '=',
          gpParentCtrl: '='
        },
        link: function (scope, element) {
          scope.$on('$destroy', function(){
              element.remove();
            });
        },
        controller: 'CourseCardCtrl',
        controllerAs: 'ctrl'
      }
    });
})();
