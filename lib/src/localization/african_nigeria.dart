import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        // TODO: import the map of supported languages here to minimize the code and keep it clean
        'en_US': {
          'hello': 'Hello World',
        },

        // dutch
        'de_DE': {
          'hello': 'Hallo Welt',
        },

        // igbo
        'igbo': {
          'Hello': 'igbo text',
        },

        // housa
        'housa': {
          'Hello': 'Housa Text',
        },

        // yoruba
        'yoruba': {
          'Hello': 'Yoruba Text',
        },

        // housa
        'efik': {
          'Hello': 'Ado-die',
        },
      };
}

// TODO: Use getx and the language text constants to enable switch between the supported languages for the application. LINK(https://pub.dev/packages/get)