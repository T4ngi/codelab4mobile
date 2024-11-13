import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/modules/home/views/voice/voice_controller.dart'; 
 
import 'package:get/get.dart'; 
 

 
class VoiceHome extends GetView<VoiceController> { 
  const VoiceHome({Key? key}) : super(key: key); 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: const Text("Speech to Text Example"), 
      ), 
      body: Padding( 
        padding: const EdgeInsets.all(16.0), 
        child: Column( 
          children: [ 
            Obx(() => Text( 
              controller.text.value, // Menampilkan teks yang dihasilkan dari 

              style: const TextStyle(fontSize: 24), 
            )), 
            const SizedBox(height: 20), 
            Obx(() => controller.isListening.value 
                ? ElevatedButton( 
                    onPressed: controller.stopListening, 
                    child: const Text("Stop Listening"), 
                  ) 
                : ElevatedButton( 
                    onPressed: controller.startListening, 
                    child: const Text("Start Listening"), 
                  )), 
          ], 
        ), 
      ), 
    ); 
  } 
} 