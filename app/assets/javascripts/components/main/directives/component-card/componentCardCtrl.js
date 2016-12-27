(function () {
  angular.module('gradepal.main.controllers').controller('ComponentCardCtrl', ComponentCardCtrl);

  ComponentCardCtrl.$inject = ['$scope', '$http', 'flash'];

  function ComponentCardCtrl($scope, $http, flash) {
    var ctrl = this;
    ctrl.editing = false;

    ctrl.init = function () {
      ctrl.component = $scope.gpComponent ? $scope.gpComponent : {};
      // ctrl.component.id = $scope.gpComponentId;
      ctrl.editing = $scope.gpEditing;
      ctrl.addingGrade = false;
      ctrl.isSelected = false;
      ctrl.getGrades();
    }

    ctrl.showNewGrade = function () {
      ctrl.addingGrade = true; // view will show the appropriate box
    }

    ctrl.toggleSelect = function () {
      ctrl.isSelected = !ctrl.isSelected;
    }

    ctrl.removeGrade = function (gradeId) {
      ctrl.component.grades = ctrl.component.grades.filter(function(grade) { return grade.id != gradeId; });
    }

    ctrl.addGrade = function (grade) {
      ctrl.component.grades.push(grade);
    }

    ctrl.getGrades = function () {
      if(ctrl.component.id) {
        $http.get('/grades', {params: {component_id: ctrl.component.id, format:'json'}}).then(function(results){
          ctrl.component.grades = results.data.sort(function (a,b) {
            return a.id - b.id;
          });
        });
      }
    }

    ctrl.edit = function () {
      ctrl.editing = true;
      ctrl.temp = {name: ctrl.component.name, weight: ctrl.component.weight};
      console.log('Editing component with id: ' + ctrl.component.id);
    }

    ctrl.delete = function () {
      console.log('Deleting component with id: ' + ctrl.component.id);
      $http.delete('/components/'+ ctrl.component.id).then(function(){
        $scope.$destroy();
      });
      $scope.gpCourseCtrl.removeComponent(ctrl.component.id);
    }

    ctrl.save = function () {
      console.log('Saving component with name: ' + ctrl.component.name + ', weight: ' + ctrl.component.weight );
      var onError = function (_httpResponse) {
        flash.error = 'Something went wrong';
      }
      if (!ctrl.component.name) { // bad input
        flash.error = 'Please enter a name for the component';
        return;
      }
      if (!ctrl.component.weight) { // bad input
        flash.error = 'Please enter a weight for the component';
        return;
      }
      ctrl.editing = false; // successful, so close dialog

      if(ctrl.component.id) { // This is an existing component if it already has an id; editing, not creating
        $http.put('/components/'+ ctrl.component.id, ctrl.component, {params: {format:'json'}}).then(function(){
          console.log('Updated component with id: ' + ctrl.component.id);
        });
      }
      else { // This is a new component if it does not have an id
        ctrl.component.course_id = $scope.gpCourseId;
        $http.post('/components', ctrl.component, {params: {format:'json'}}).then(function(results){
          ctrl.component = results.data;
          console.log('Created component with id: ' + ctrl.component.id);
          $scope.gpCourseCtrl.addComponent(results.data);
          $scope.gpCourseCtrl.addingComponent = false;
        });
      }
    }

    ctrl.cancel = function () {
      console.log('Cancelling edit');
      if(ctrl.component.id && ctrl.temp) { // existing component
        console.log('a');
        ctrl.component.name = ctrl.temp.name;
        ctrl.component.weight = ctrl.temp.weight;
      }
      ctrl.editing = false;
      $scope.gpCourseCtrl.addingComponent = false;
    }

    ctrl.init();
  }

})();
