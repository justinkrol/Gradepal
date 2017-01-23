(function () {
  angular.module('gradepal.main.controllers').controller('GradeCardCtrl', GradeCardCtrl);

  GradeCardCtrl.$inject = ['$scope', '$http', 'flashService'];

  function GradeCardCtrl($scope, $http, flashService) {
    var ctrl = this;
    ctrl.editing = false;

    ctrl.init = function () {
      if($scope.gpGrade) {
        ctrl.grade = $scope.gpGrade;
        ctrl.grade.fullScore = ctrl.grade.score + '/' + ctrl.grade.max;
      }
      else {
        ctrl.grade = {};
        ctrl.grade.fullScore = '';
      }
      // ctrl.grade.id = $scope.gpGradeId;
      ctrl.editing = $scope.gpEditing;
    }

    ctrl.edit = function () {
      ctrl.editing = true;
      ctrl.temp = {name: ctrl.grade.name, fullScore: ctrl.grade.fullScore};
      console.log('Editing grade with id: ' + ctrl.grade.id);
    }

    ctrl.delete = function () {
      console.log('Deleting grade with id: ' + ctrl.grade.id);
      $http.delete('/grades/'+ ctrl.grade.id).then(function(){
        $scope.$destroy();
      });
      $scope.gpComponentCtrl.removeGrade(ctrl.grade.id);
    }

    ctrl.save = function () {
      ctrl.grade.max = parseInt(ctrl.grade.fullScore.split('/')[1]);
      ctrl.grade.score = parseInt(ctrl.grade.fullScore.split('/')[0]);
      console.log('Saving grade with name: ' + ctrl.grade.name + ', score: ' + ctrl.grade.score + ', max: ' + ctrl.grade.max);
      // Existing grade
      if(ctrl.grade.id) {
        $http.put('/grades/'+ctrl.grade.id, ctrl.grade, {params: {format: 'json'}}).then(function(){
          console.log('Updated grade with id: ' + ctrl.grade.id);
          ctrl.editing = false;
        }, function(results){
          flashService.showErrors(results.data.errors);
        });
      }
      // New grade
      else {
        ctrl.grade.component_id = $scope.gpComponentCtrl.component.id;
        $http.post('/grades', ctrl.grade, {params: {format: 'json'}}).then(function(results){
          ctrl.grade = results.data;
          console.log('Created grade with id: ' + ctrl.grade.id);
          $scope.gpComponentCtrl.addGrade(results.data);
          $scope.gpComponentCtrl.addingGrade = false;
          ctrl.editing = false;
        }, function(results){
          flashService.showErrors(results.data.errors);
        });
      }
    }

    ctrl.cancel = function () {
      console.log('Cancelling edit');
      if(ctrl.grade.id && ctrl.temp) { // existing grade
        console.log('a');
        ctrl.grade.name = ctrl.temp.name;
        ctrl.grade.fullScore = ctrl.temp.fullScore;
      }
      ctrl.editing = false;
      $scope.gpComponentCtrl.addingGrade = false;
    }

    ctrl.init();
  }

})();
