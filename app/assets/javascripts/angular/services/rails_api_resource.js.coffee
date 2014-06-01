angular.module('RailsApiResource', ['ngResource'])

  .constant('KOPOOL_CONFIG',
    {
      PROTOCOL: 'http',
      HOSTNAME: 'localhost:3000',
    })

  .factory 'RailsApiResource', ($http, KOPOOL_CONFIG, $cookieStore) ->

    (resourceName, rootNode) ->
      console.log("(RailsApiResource) resourceName:" + resourceName)

      collectionUrl = KOPOOL_CONFIG.PROTOCOL + '://' + KOPOOL_CONFIG.HOSTNAME + '/' + resourceName + '.json'

      defaultParams = { }
      headers = { }

      # Utility methods
      getId = (data) ->
        data._id.$oid

      # A constructor for new resources
      Resource = (data) ->
        angular.extend(this, data)

      # TODO: This could be DRYed up a _LOT_!! Notice that each .then is identical..  Use a response factory?
      Resource.query = (queryJson) ->
        console.log("(RailsApiResource.Resource.query) queryJson="+queryJson)
        params = if angular.isObject(queryJson) then queryJson else {}
        console.log("(RailsApiResource.Resource.query) params="+params)

        #, headers: headers
        $http.get(collectionUrl, {params:angular.extend({}, defaultParams, params)} ).then( (response) ->
          result = []
          console.log("(RailsApiResource.query) response="+response.data)

          if response.data instanceof Array
            console.log("is an Array")
            angular.forEach(response.data, (value, key) ->
              console.log("key:" + key + " value:" + value)
              result[key] = new Resource(value)
            )
          else
            console.log("is an Object")
            data_of_interest = eval("response.data."+rootNode)
            angular.forEach(data_of_interest, (value, key) ->
              result[key] = new Resource(value)
            )
          )

      Resource.get = (id) ->
        console.log("Resource.get id="+id)
        singleItemUrl = KOPOOL_CONFIG.PROTOCOL + '://' + KOPOOL_CONFIG.HOSTNAME + '/' + resourceName + '/' + id + '.json'
        console.log("url will be "+singleItemUrl)
        $http.get(singleItemUrl, {params:defaultParams}).then( (response) ->
          result = []
          console.log("(RailsApiResource.get) response="+response.data)

          if response.data instanceof Array
            console.log("(get) is an Array")
            angular.forEach(response.data, (value, key) ->
              console.log("key:" + key + " value:" + value)
              result[key] = new Resource(value)
            )
          else
            console.log("(get) is an Object")
            angular.forEach(response.data, (value, key) ->
              result[key] = new Resource(value)
            )
          )

      Resource.save = (data) ->
        console.log("Resource.save")
        singleItemUrl = KOPOOL_CONFIG.PROTOCOL + '://' + KOPOOL_CONFIG.HOSTNAME + '/' + resourceName + '/' + data.id + '.json'
        console.log("url will be "+singleItemUrl)
        $http.put(singleItemUrl, data, { params:defaultParams }).then( (response) ->
          new Resource(data)
        )

      Resource.remove = (data) ->
        console.log("Resource.remove")
        singleItemUrl = KOPOOL_CONFIG.PROTOCOL + '://' + KOPOOL_CONFIG.HOSTNAME + '/' + resourceName + '/' + data.id + '.json'
        console.log("url will be "+singleItemUrl)
        $http.delete(singleItemUrl, data, { params:defaultParams }).then( (response) ->
          new Resource(data)
        )

      Resource.create = (data) ->
        console.log("Resource.create")
        console.log("url will be "+collectionUrl)
        $http.post(collectionUrl, data, { params:defaultParams }).then( (response) ->
          result = []
          console.log("(RailsApiResource.create) response="+response.data)

          if response.data instanceof Array
            console.log("(get) is an Array")
            angular.forEach(response.data, (value, key) ->
              console.log("key:" + key + " value:" + value)
              result[key] = new Resource(value)
            )
          else
            console.log("(get) is an Object")
            angular.forEach(response.data, (value, key) ->
              result[key] = new Resource(value)
            )
          )

      # Instance Methods (not yet tested!)

      Resource.prototype.$save = (data) ->
        Resource.save(this)

      Resource
