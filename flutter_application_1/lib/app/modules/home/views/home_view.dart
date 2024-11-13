import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../controllers/home_controller.dart';
import 'voice/voice_controller.dart';

class HomeView extends StatelessWidget { 
  const HomeView({Key? key}) : super(key: key);

  @override 
  Widget build(BuildContext context) { 
    // Inisialisasi controller menggunakan Get.put
    final HomeController homeController = Get.put(HomeController());
    final VoiceController voiceController = Get.put(VoiceController());

    return Scaffold( 
      appBar: AppBar( 
        title: const Text('Image, Video & Voice Control'), 
        elevation: 4, 
      ), 
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column( 
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              _buildImagePickerSection(homeController),
              const Divider(color: Colors.grey, thickness: 1),
              _buildVideoPickerSection(homeController),
              const Divider(color: Colors.grey, thickness: 1),
              _buildVoiceControlSection(voiceController),
            ],
          ),
        ),
      ), 
    ); 
  }

  // Widget Bagian Image Picker
  Widget _buildImagePickerSection(HomeController controller) {
    return Column(
      children: [
        const Text(
          'Image Picker',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: Get.height / 2.5,
          width: Get.width * 0.7,
          child: Obx(() { 
            return controller.isImageLoading.value 
                ? const CircularProgressIndicator() 
                : controller.selectedImagePath.value.isEmpty 
                    ? const Text('No image selected') 
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20), 
                        child: Image.file(
                          File(controller.selectedImagePath.value),
                          fit: BoxFit.cover,
                        ), 
                      ); 
          }), 
        ), 
        const SizedBox(height: 20), 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => controller.pickImage(ImageSource.camera), 
              child: const Text('Camera'),
            ), 
            ElevatedButton(
              onPressed: () => controller.pickImage(ImageSource.gallery), 
              child: const Text('Gallery'),
            ), 
          ],
        ),
      ],
    );
  }

  // Widget Bagian Video Picker
  Widget _buildVideoPickerSection(HomeController controller) {
    return Column(
      children: [
        const Text(
          'Video Picker',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox( 
          height: Get.height / 2.5, 
          width: Get.width * 0.7, 
          child: Obx(() { 
            if (controller.selectedVideoPath.value.isNotEmpty) { 
              return Card( 
                child: Column( 
                  children: [ 
                    AspectRatio( 
                      aspectRatio: controller.videoPlayerController?.value.aspectRatio ?? 1.0, 
                      child: VideoPlayer(controller.videoPlayerController!), 
                    ), 
                    VideoProgressIndicator(
                      controller.videoPlayerController!, 
                      allowScrubbing: true, 
                      colors: VideoProgressColors(playedColor: Colors.blue),
                    ),
                    IconButton( 
                      icon: Icon(
                        controller.isVideoPlaying.isTrue 
                            ? Icons.pause 
                            : Icons.play_arrow, 
                      ), 
                      onPressed: controller.togglePlayPause, 
                    ), 
                  ], 
                ), 
              ); 
            } else { 
              return const Text('No video selected'); 
            } 
          }), 
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => controller.pickVideo(ImageSource.camera),
              child: const Text('Camera'),
            ),
            ElevatedButton(
              onPressed: () => controller.pickVideo(ImageSource.gallery),
              child: const Text('Gallery'),
            ),
          ],
        ),
      ],
    );
  }

  // Widget Bagian Voice Control
  Widget _buildVoiceControlSection(VoiceController controller) {
    return Column(
      children: [
        const Text(
          'Voice Control',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Obx(() => Text(
          controller.text.value, 
          style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
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
    );
  }
}
