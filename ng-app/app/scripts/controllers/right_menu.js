'use strict';

/**
 * @ngdoc function
 * @name animefolio.controller:LeftMenuCtrl
 * @description
 * # LeftMenuCtrl
 * Controller of the animefolio
 */

angular.module("animefolio").controller("RightMenuCtrl", function ($scope, $location, http) {

  $scope.initialize = function () {
    $scope.api.sunday_map    = [];
    $scope.api.monday_map    = [];
    $scope.api.tuesday_map   = [];
    $scope.api.wednesday_map = [];
    $scope.api.thursday_map  = [];
    $scope.api.friday_map    = [];
    $scope.api.saturday_map  = [];
    http.getRecentList($scope.api);
  }
});

