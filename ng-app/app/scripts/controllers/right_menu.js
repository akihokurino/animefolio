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
    http.getRecentList($scope);
  }
});

