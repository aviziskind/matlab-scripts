function setMatlabWindowTitle(str)
    if isJavaRunning
        jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
        if ~isempty(jDesktop.getMainFrame)
            jDesktop.getMainFrame.setTitle(str);
        end
    end
end