(function () {
  angular.module('gradepal.main.directives')
    .directive('gpGradeCard', function ($compile) {
      return {
        restrict: 'E',
        templateUrl: 'components/main/directives/grade-card/grade-card-view.html',
        scope: {
          gpComponentCtrl: '=',
          gpGrade: '=',
          gpEditing: '='

        },
        link: function (scope, element) {
          scope.$on('$destroy', function(){
              element.remove();
            });
        },
        controller: 'GradeCardCtrl',
        controllerAs: 'ctrl'
      }
    });
})();
