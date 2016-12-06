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
          scope.$watch("gpCourse",function(newValue,oldValue) {
            console.log('Course changed from ' + oldValue.id + ' to ' + newValue.id);
          });
          scope.$on('$destroy', function(){
              element.remove();
            });
        },
        controller: 'CourseCardCtrl',
        controllerAs: 'ctrl'
      }
    });
})();
