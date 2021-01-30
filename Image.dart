//# ImagePickerModel
//Here is the working model of Image Picker...
//==============Dependencies==============================
//image_picker: ^0.6.0+17
//firebase_storage: ^3.0.3

//=================Import========================

import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:path/path.dart' as Path;
import 'package:image_picker/image_picker.dart'; // For Image Picker

//=========================================================



//========================Variable Used=======================
bool isloading = false; //false initially,show loading until image get upload to firebase.
String _uploadUrl;//return Url to download image from it.
File _image;//Stored the image path; 

//========================

//Is here the Image Picker function ......(Can allow to Capture the Image with required Spec.)

//====================================

 captureImage()async{
    final capture = ImagePicker();
await capture.getImage(
  source: ImageSource.camera,
  maxHeight: 450,
  maxWidth: 450,
  imageQuality: 60,
).then((capturedImage) =>
setState((){
  _image = File(capturedImage.path);
  print(_image);
})
);

UploadingImage();//Calling Upload Image from CaptureImage , so that once image taken it automatically get Upload.
  }

//====================================
//###Here is the UploadingImage class 

//================================


UploadingImage()async{
   setState(() {
     isloading = true;
   });
    StorageReference storageReference = FirebaseStorage.instance.ref().child("Image/${Path.basename(_image.path)}");
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print("File Uploaded");//once file get uploaded 
    storageReference.getDownloadURL().then((value) =>
    setState((){
      _uploadUrl = value;//its having url here you can download or show image to user 
      print(_uploadUrl);
      isloading = false;
    })
    );

  }


//================================





//##Simply Call captureImage() from anywhere everthing get done automatically.





//=========================================================================Example================================================================================================

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}
File _image;
String _uploadUrl;
class _CameraState extends State<Camera> {
bool isloading=false;
  captureImage()async{
    final capture = ImagePicker();
await capture.getImage(
  source: ImageSource.camera,
  maxHeight: 450,
  maxWidth: 450,
  imageQuality: 60,
).then((capturedImage) =>
setState((){
  _image = File(capturedImage.path);
  print(_image);
})
);

UploadingImage();
  }

  UploadingImage()async{
   setState(() {
     isloading = true;
   });
    StorageReference storageReference = FirebaseStorage.instance.ref().child("Image/${Path.basename(_image.path)}");
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print("File Uploaded");
    storageReference.getDownloadURL().then((value) =>
    setState((){
      _uploadUrl = value;
      print(_uploadUrl);
      isloading = false;
    })
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Material(

              color: Colors.red,
              child: InkWell(
                onTap: (){
                  setState(() {
                    captureImage();
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 180,
                  child:isloading?CircularProgressIndicator(): Text("capture",style: TextStyle(color: Colors.white,fontSize: 30),),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            )
          ],
        ),
      ),
    );
  }
}













