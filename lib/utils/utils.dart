
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';


String formatDate(String? date) {
  if (date != null && date.isNotEmpty) {
    DateTime dDate = DateFormat('y-M-d').parse(date);
    return DateFormat("MMM -yy").format(dDate);
  } else {
    return "";
  }
}



/*  ******Function to get http success status***** */
bool isHttpStatusSuccess(int statusCode) {
  if (kDebugMode) {
    print(statusCode);
  }

  return statusCode >= 200 && statusCode < 300;
}

/*  ******Function to generate http error message***** */
String generateHttpErrorMessage(int errorCode) {
  switch (errorCode) {
    case 400:
      return "400 Bad Request: The server cannot process the request due to a client error.";
    case 401:
      return "401 Unauthorized: The request has not been applied because it lacks valid authentication credentials for the target resource.";
    case 403:
      return "403 Forbidden: The server understood the request but refuses to authorize it.";
    case 404:
      return "404 Not Found: The server cannot find the requested resource.";
    case 405:
      return "405 Method Not Allowed: The method specified in the request is not allowed for the resource identified by the request.";
    case 406:
      return "406 Not Acceptable: The server cannot produce a response matching the list of acceptable values.";
    case 408:
      return "408 Request Timeout: The server did not receive a complete request message within the time that it was prepared to wait.";
    case 409:
      return "409 Conflict: The request could not be completed due to a conflict with the current state of the target resource.";
    case 410:
      return "410 Gone: The requested resource is no longer available and will not be available again.";
    case 500:
      return "500 Internal Server Error: The server encountered an unexpected condition that prevented it from fulfilling the request.";
    case 501:
      return "501 Not Implemented: The server does not support the functionality required to fulfill the request.";
    case 502:
      return "502 Bad Gateway: The server, while acting as a gateway or proxy, received an invalid response from an inbound server it accessed while attempting to fulfill the request.";
    case 503:
      return "503 Service Unavailable: The server is currently unable to handle the request due to temporary overloading or maintenance of the server.";
    case 504:
      return "504 Gateway Timeout: The server, while acting as a gateway or proxy, did not receive a timely response from an upstream server it needed to access in order to complete the request.";
    case 505:
      return "505 HTTP Version Not Supported: The server does not support, or refuses to support, the HTTP protocol version that was used in the request message.";
    default:
      return "$errorCode: Unknown Error";
  }
}

String formatDateTime({required String dateTimeString}) {
  // Parse the given date-time string to a DateTime object
  DateTime dateTime = DateTime.parse(dateTimeString);

  // Format the DateTime object to the desired format
  DateFormat dateFormat = DateFormat("d MMM y, h:mm a");

  // Convert to the desired time zone (for example, Australia/Sydney)
  // You can change this to any other time zone if needed
  dateTime = dateTime.toLocal(); // Converts to local time zone

  String formattedDate = dateFormat.format(dateTime);

  // Add the desired time zone abbreviation
 // String timeZone = "(AU)"; // Australian time zone abbreviation

  return formattedDate;
}

String formatDecimalPoint({required String data, required int length}) {
  if (data.isEmpty) return data;

  double parsedDistance = double.tryParse(data) ?? 0.0;
  return parsedDistance.toStringAsFixed(1);
}

