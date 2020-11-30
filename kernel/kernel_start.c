void main() {
    char* video_address = (char*) 0xb8000;
    char* start_kernel = "Welcome HDZhang's OS Kernel, Staring...";
    int index;
    for(index = 0; *(start_kernel + index) != 0x0; index++) {
        video_address[index*2] = *(start_kernel + index);
        video_address[index*2+1] = 0x0f;
    }
    return;
}
