<?php
/**
 * Util
 *
 * @author      code generate
 * @package   	Kiss
 * @version     $Id$
 */
class Function_Common {

    /**
     * Truncate a lenght text
     *
     * @param string $string
     * @param int $length
     * @param string $etc
     * @param string $charset
     * @param bool $break_words
     * @param bool $middle
     * @return string
     */
    static public function truncateText($string, $length = 80, $etc = '...', $charset='UTF-8',$break_words = false, $middle = false){

        $string = strip_tags($string);

        if ($length == 0)
            return '';

        if (strlen($string) > $length) {
            $length -= min($length, strlen($etc));
            if (!$break_words && !$middle) {
                $string = preg_replace('/\s+?(\S+)?$/', '', mb_substr($string, 0, $length+1, $charset));
            }
            if(!$middle) {
                $string = mb_substr($string, 0, $length, $charset) . $etc;
            } else {
                $string = mb_substr($string, 0, $length/2, $charset) . $etc . mb_substr($string, -$length/2, $charset);
            }
        }

        return $string;
    }
    /**
     * Encrypt password
     *
	 * @param string $password
	 * @param string $salt
     * @return string
     */
    static public function encrypt($string, $salt) {
        return sha1(trim($string).$salt);
    }
    /**
     * Generate salt with lenght default is 3
     *
     * @param int $length
	 * @return string
     */
    static public function generateCode($length=3){
        $string   = "";
        $possible = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        for($i=0;$i < $length;$i++) {
            $char = $possible[mt_rand(0, strlen($possible)-1)];
            $string .= $char;
        }
        return $string;
    }

    static public function isTheDay ($date)
    {
        $today = date("Y-m-d");
        $yesterday = date("Y-m-d", mktime(0, 0, 0, date("m"), date("d") - 1, date("Y")));
        $tomorrow = date("Y-m-d",  mktime(0, 0, 0, date("m"), date("d") + 1, date("Y")));
        $the_day = date('Y-m-d', strtotime($date) );
        if ($the_day == $today)
            return 'Today';
        elseif ($the_day == $yesterday)
            return 'Yesterday';
        elseif ($the_day == $tomorrow)
            return 'Tomorrow';
        return $the_day;
    }

    static public function killProcess($searchString ){
//        echo `kill -9 17502`;
        $command = "ps -o '%p;%a' | grep '$searchString'| grep ';php' | grep -v 'sh' | grep -v 'grep'";
        $processString = shell_exec($command);
        $processString = trim($processString);
        $tmpArray = explode(';', $processString);
        if(count($tmpArray)>1){
            $pid = intval($tmpArray[0]);
            $killCommand = "kill -9 $pid";
            shell_exec($killCommand);
            return true;
        }
        return false;
    }
    
    static public function isRunningProcess($searchString ){
//        echo `kill -9 17502`;
        $command = "ps -o '%p;%a' | grep '$searchString'| grep ';php' | grep -v 'sh' | grep -v 'grep'";
        $processString = shell_exec($command);        
        $processString = trim($processString);
        $tmpArray = explode(';', $processString);
        if(count($tmpArray)>1){
            return true;
        }
        return false;
    }
    


    static public function countRunningProcess($searchString ){
//        echo `kill -9 17502`;
        $command = "ps -o '%p;%a' | grep '$searchString'| grep ';php' | grep -v 'sh' | grep -v 'grep'";
        $processString = shell_exec($command);
        $processString = trim($processString);
        $tmpArray = explode("\n", $processString);
        $count = count($tmpArray);
        return $count;
    }
    

}