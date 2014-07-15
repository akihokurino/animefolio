angular.module("animefolio").factory("env", function(){
  //var HOST = "http://127.0.0.1:3000";
  var HOST = "http://animefolio.com/api";

  return {
    getHost: function(){
      return HOST;
    }
  }
})
