function setMatlabWindowTitle(str)
    if isJavaRunning
        jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
        jDesktop.getMainFrame.setTitle(str);
    end
end