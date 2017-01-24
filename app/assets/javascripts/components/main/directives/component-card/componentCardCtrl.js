(function () {
  angular.module('gradepal.main.controllers').controller('ComponentCardCtrl', ComponentCardCtrl);

  ComponentCardCtrl.$inject = ['$scope', '$http', 'flashService'];

  function ComponentCardCtrl($scope, $http, flashService) {
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
      if(window.confirm("Are you sure you want to delete '" + ctrl.component.name + "'?")){
        console.log('Deleting component with id: ' + ctrl.component.id);
        $http.delete('/components/'+ ctrl.component.id).then(function(){
          $scope.gpCourseCtrl.removeComponent(ctrl.component.id);
          flashService.message('error', 'Deleted component: ' + ctrl.component.name);
          $scope.$destroy();
        });
      }
    }

    ctrl.save = function () {
      console.log('Saving component with name: ' + ctrl.component.name + ', weight: ' + ctrl.component.weight );
      // Existing component
      if(ctrl.component.id) {
        $http.put('/components/'+ ctrl.component.id, ctrl.component, {params: {format:'json'}}).then(function(){
          console.log('Updated component with id: ' + ctrl.component.id);
          ctrl.editing = false;
          flashService.message('success', 'Successfully saved component: ' + ctrl.component.name);
        }, function(results){
          flashService.errors(results.data.errors);
        });
      }
      // New component
      else {
        ctrl.component.course_id = $scope.gpCourseId;
        $http.post('/components', ctrl.component, {params: {format:'json'}}).then(function(results){
          ctrl.component = results.data;
          console.log('Created component with id: ' + ctrl.component.id);
          $scope.gpCourseCtrl.addComponent(results.data);
          $scope.gpCourseCtrl.addingComponent = false;
          ctrl.editing = false;
          flashService.message('success', 'Successfully saved component: ' + ctrl.component.name);
        }, function(results){
          flashService.errors(results.data.errors);
        });
      }
    }

    ctrl.cancel = function () {
      console.log('Cancelling edit');
      if(ctrl.component.id && ctrl.temp) { // existing component
        ctrl.component.name = ctrl.temp.name;
        ctrl.component.weight = ctrl.temp.weight;
      }
      ctrl.editing = false;
      $scope.gpCourseCtrl.addingComponent = false;
    }

    ctrl.average = function () {
      if (ctrl.component.grades && ctrl.component.grades.length > 0) {
        return ((ctrl.component.grades.reduce(function(a,b) {return a + (b.score / b.max);}, 0) * 100
          / ctrl.component.grades.length)).toFixed(1) + '%';
      }
      else {
        return 'No grades';
      }
    }

    ctrl.init();
  }

})();
