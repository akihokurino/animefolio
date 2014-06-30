'use strict';

/**
 * @ngdoc function
 * @name animefolio.controller:MenuCtrl
 * @description
 * # MenuCtrl
 * Controller of the animefolio
 */

angular.module("animefolio").controller("MenuCtrl", function ($scope, $location) {
	$scope.isSelected = function (this_letter) {
		var letter = $location.search().letter;
		if(this_letter == letter){
			return "selected";
		}
	}

	$scope.isDefault = function () {
		var letter = $location.search().letter;
		var keyword = $location.search().keyword;
		if(!letter && !keyword) {
			return "selected";
		}
	}
});

