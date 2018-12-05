class Resource<T> {
  final Status status;
  final T data;
  final String message;

  Resource({this.data, this.message, this.status});

  factory Resource.success({T data, String message}) {
    return Resource(data: data, message: message, status: Status.SUCCESS);
  }

  factory Resource.error({T data, String message}) {
    return Resource(data: data, message: message, status: Status.ERROR);
  }

  factory Resource.loading({T data, String message}) {
    return Resource(data: data, message: message, status: Status.LOADING);
  }
}

enum Status { SUCCESS, LOADING, ERROR }
