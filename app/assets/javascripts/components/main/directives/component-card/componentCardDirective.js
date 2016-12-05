(function () {
  angular.module('gradepal.main.directives')
    .directive('gpComponentCard', function ($compile) {
      return {
        restrict: 'E',
        templateUrl: 'components/main/directives/component-card/component-card-view.html',
        scope: {
          gpCourseCtrl: '=',
          gpCourseId: '=',
          gpComponent: '=',
          gpEditing: '='

        },
        link: function (scope, element) {
          scope.$on('$destroy', function(){
              element.remove();
            });
        },
        controller: 'ComponentCardCtrl',
        controllerAs: 'ctrl'
      }
    });
})();
