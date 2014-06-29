'use strict';

/**
 * @ngdoc function
 * @name ngAppApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the ngAppApp
 */

angular.module("animefolio").controller("MainCtrl", function ($scope, http) {
 	$scope.initialize = function () {
 		http.getFilms()
 	}
});
