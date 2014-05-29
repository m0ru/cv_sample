import CV.Image
--import CV.Edges
import CV.Histogram as H
import CV.ColourUtils
import Control.Applicative

-- main = do
--         image <- readFromFile "Paris.jpg" :: IO (Image GrayScale D32)
--         let result = sobel (1,0) s5 image
--         saveImage "Result.png" result

unsafeLoadRgb8 :: FilePath -> IO (Image RGB D8)
unsafeLoadRgb8 path = do
    img'' <- loadColorImage path
    let 
        -- TODO will cause an error here if the image can't be loaded   
        Just img' = img'' 

        -- ignore unsafe here. it just signals 
        -- the loss of information from 32 to 8 bit
        img = bgrToRgb $ unsafeImageTo8Bit img'

    return img

rgbHist img = let 
                  mask = Nothing -- would allow to limit the relevant area
                  accumulate = False -- would allow to add multiple imgs into one hist
                  bins = 64
              --TODO how does this handle the individual channels?
              --in histogram [ (getChannel Red   img, bins)
                           -- , (getChannel Green img, bins)
                           -- , (getChannel Blue  img, bins)] accumulate mask 
              in histogram [ (getChannel Red   img, bins)
                           , (getChannel Green img, bins)
                           , (getChannel Blue  img, bins)] accumulate mask 


main = do
    aHist <- rgbHist <$> unsafeLoadRgb8 "Beksinski3.jpg"
    bHist <- rgbHist <$> unsafeLoadRgb8 "Beksinski3_greenish.jpg"

    putStrLn (aHist `seq` "ahist evaluated")
    putStrLn (bHist `seq` "bhist evaluated")

--    putStrLn $ show $ H.compareHistogram aHist bHist 0
    return ()


    

    -- let hist = H.Histogram [(unsafeImageTo8Bit $ getChannel Red sample,64)
    
    -- let hist = H.histogram [(unsafeImageTo8Bit $ getChannel Red sample,64)
    --                          ,(unsafeImageTo8Bit $ getChannel Green sample,64)
    --                          ,(unsafeImageTo8Bit $ getChannel Blue sample,64)] False Nothing
    --
    --
    -- Stopped @: 
    --Histogram.chs:62
    --ImgProc.hsc:151
    --
    --     res = backProjectHistogram [unsafeImageTo8Bit $ getChannel Red full
    --                                 ,unsafeImageTo8Bit $ getChannel Green full
    --                                 ,unsafeImageTo8Bit $ getChannel Blue full] hist
    -- saveImage "generated.png" $ stretchHistogram $ unsafeImageTo32F res
    --
    --
    --
    --

-- CVAPI(double)  cvCompareHist( const CvHistogram* hist1,
--                              const CvHistogram* hist2,
--                              int method);

-- getHistogramBin (I.Histogram hs) n = unsafePerformIO $ withForeignPtr hs (\h -> I.c'cvGetHistValue_1D (castPtr h) n)
    --
--double cv::compareHist( InputArray _H1, InputArray _H2, int method )
    --
-- CV_IMPL void
-- cvCalcArrHist( CvArr** img, CvHistogram* hist, int accumulate, const CvArr* mask )
    --
-- void cv::calcHist( const Mat* images, int nimages, const int* channels,
--                InputArray _mask, SparseMat& hist, int dims, const int* histSize,
--                const float** ranges, bool uniform, bool accumulate )
-- {
--     Mat mask = _mask.getMat();
--     calcHist( images, nimages, channels, mask, hist, dims, histSize,
--               ranges, uniform, accumulate, false );
-- }


-- void cv::calcHist( InputArrayOfArrays images, const vector<int>& channels,
--                    InputArray mask, OutputArray hist,
--                    const vector<int>& histSize,
--                    const vector<float>& ranges,
--                    bool accumulate )
