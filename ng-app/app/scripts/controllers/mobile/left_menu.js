'use strict';

/**
 * @ngdoc function
 * @name animefolio.controller:LeftMenuCtrl
 * @description
 * # LeftMenuCtrl
 * Controller of the animefolio
 */

angular.module("animefolio").controller("LeftMenuCtrl", function ($scope, $location) {
	$scope.isSelected = function (this_letter) {
		var letter = $location.search().letter;
		if(this_letter == letter){
			return "selected";
		}
	}

	$scope.isDefault = function () {
		var letter = $location.search().letter;
		var keyword = $location.search().keyword;
		var type = $location.search().type;
		if(!letter && !keyword && !type) {
			var url_array = $location.path().split("/");
			var page = url_array[1];
			if(page == ""){
				return "selected";
			}
		}
	}

	$scope.isPopular = function () {
		var type = $location.search().type;
		return (type == "popular") ? "selected" : "";
	}

	$scope.isRecent = function () {
		var type = $location.search().type;
		return (type == "recent") ? "selected" : "";
	}
});

