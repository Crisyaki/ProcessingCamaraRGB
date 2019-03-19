import processing.video.*;
import cvimage.*;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.imgproc.Moments;
import java.util.*;

Capture cam;

CVImage cv; 
PImage imgPrueba, pImg;
boolean colores = true;
int idx, mid;
void setup() {
  size(1280, 960);
  //Cámara
  cam = new Capture(this, width/2 , height/2);
  cam.start(); 
  
  //OpenCV
  //Carga biblioteca core de OpenCV
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  //Crea imágenes
  pImg = createImage(1, cam.height, ARGB);
  idx = 0;
  mid = cam.width/2;
  cv=new CVImage(cam.width, cam.height);


}
void draw() {  
  if (!cam.available()) {
    return;
  }
  
  if(colores){
    background(0);
    cam.read();
    contornosRGB();
  }else{
    cam.read();
    pImg.copy(cam, mid, 0, 1, cam.height, 0, 0, pImg.width, pImg.height);
    image(pImg, idx, 0);
    idx++;
    idx %= width;
  }
  
}

void contornosRGB(){
    cv.copyTo(cam); //Ponemos el frame de la cam en el objeto CVImage
    Mat hsv = cv.getBGRA(); //Obtenemos el Mat a color 
    Imgproc.cvtColor(hsv, hsv, Imgproc.COLOR_BGR2HSV); 
 
    //Pasar de img a Mat
    Mat imgAzul = new Mat();
    Mat imgVerde = new Mat();
    Mat imgRojo = new Mat();
    //Detectamos los valores entre los escalares indicados
    Core.inRange(hsv,new Scalar(26,26,57),new Scalar(200,255,255),imgAzul); //Detectar azul
    Core.inRange(hsv,new Scalar(0,100,100),new Scalar(10,255,255),imgRojo);
    Core.inRange(hsv,new Scalar(41,42,60),new Scalar(80,255,255),imgVerde);
    
    //Core.flip(imgColor,imgColor,2; //Imagen en modo espejo
    cv.copyTo(imgAzul);
    image(cam,0,0);
    image(cv,width/2,height/2);
    cv.copyTo(imgRojo);
    image(cv,0,height/2);
    cv.copyTo(imgVerde);
    image(cv,width/2,0);
    
    hsv.release();
    imgAzul.release();
    imgVerde.release();
    imgRojo.release();
}

void keyPressed ( ) {
  switch(key){
    case 49: //1 --> Modo 1 detección de los colores RGB por separado
        colores=true;
        break;
    case  50: //2 --> Modo 2 Imagen con escaneo de hendidura
        colores=false;
        background(0);
        break;
  }

}
