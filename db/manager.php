<?php

class DbManager {

	protected $pdo;

	public function __construct() {
		
	}

	private static function connectToDb() {


        $configuration = parse_ini_file("/etc/config.ini");

        $dbpass = $configuration['dbPassword'];
        $dbhost = $configuration['dbHost'];
        $dbname = "MyBlog";
        $dbuser = $configuration['dbUserName'];
		$pdo = new PDO("mysql:host=$dbhost;dbname=$dbname", $dbuser, $dbpass ,  array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));

		return $pdo;
	}

    public static function getForms(){
        $conn = self::connectToDb();
        $sql = $conn->prepare("SELECT * from `forms`  WHERE `isDeleted` = 0 ORDER BY creationDate DESC");
        $sql->execute();
        $result = $sql->fetchAll(PDO::FETCH_ASSOC);
        return $result;
        exit;

    }

    public static function exportToCsv(){
        return ExportManager::exportCsv();
    }

    public static function editForm($form){

        $conn = self::connectToDb();
        $sql = "UPDATE `forms` SET";
        $comma = " ";
        foreach($form as $key => $val) {

            if( ! empty($val)) {
                $sql .= $comma . $key . " = '" . (($val)) . "'";
                $comma = ", ";
            }
        }
        $sql .= "WHERE id = ".$form->id;

        $stmt = $conn->query($sql);
        $stmt->execute();
        $result = $stmt->fetchAll();
        return $result;
    }

    public static function incNirCredit(){
        $conn = self::connectToDb();
        $sql = $conn->prepare("SELECT * from `nir`");
        $sql->execute();
        $result = $sql->fetchAll();
        $grade = $result[0]["grade"];

        $grade = $grade + 10;
        if($grade > 100){
            $grade = 100;
        }

        $conn = self::connectToDb();
        $sql = "UPDATE `nir` SET `grade` = $grade";
        $stmt = $conn->query($sql);
        $stmt->execute();
        $result = $stmt->fetchAll();
        return $result;

    }

    public static function decNirCredit(){
        $conn = self::connectToDb();
        $sql = $conn->prepare("SELECT * from `nir`");
        $sql->execute();
        $result = $sql->fetchAll();
        $grade = $result[0]["grade"];

        $grade = $grade - 10;
        if($grade < 0){
            $grade = 0;
        }

        $conn = self::connectToDb();
        $sql = "UPDATE `nir` SET `grade` = $grade";
        $stmt = $conn->query($sql);
        $stmt->execute();
        $result = $stmt->fetchAll();
        return $result;

    }



    public static function saveComments($comments , $formId){
        $conn = self::connectToDb();
        $sql = "UPDATE `forms` SET `comments` = $comments WHERE id=$formId";
        $stmt = $conn->query($sql);
        $stmt->execute();
        $result = $stmt->fetchAll();
        return $result;
        exit;

    }

    public static function setUserCookie($userId , $cookie){

    }

    public static function login($data){
        $userLogin = ($data->userLogin);
        $userPassword = md5($data->userPassword);

        $conn = self::connectToDb();
        $sql = $conn->prepare("SELECT * from `adminUsers`
                               WHERE `userLogin`  = :userLogin
                               AND  `userPassword`  = :userPassword
                               ");
        $sql->bindParam('userLogin', $userLogin);
        $sql->bindParam('userPassword', $userPassword);
        $sql->execute();
        $result = $sql->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }

    public static function deleteForm($formId){
        $conn = self::connectToDb();
        $sql = "UPDATE `forms` SET `isDeleted` = 1 WHERE id=$formId";
        $stmt = $conn->query($sql);
        $stmt->execute();
        $result = $stmt->fetchAll();
        return $result;
        exit;

    }



    /* Generic Section */

	public static function insertToDb($tableName, $data) {
		// Convert The Data from Object to Key - Value Array
		$dataArray = (array) $data;
		// Get Last Item Key
		$last_key = end(array_keys($dataArray));
		$sql = array();
		$cols = "(";
		$values = "(";
		foreach ($dataArray AS $k => $v) {
			$cols.= $k;
			$values.= ':' . $k;
			if ($k == $last_key) {
				
			} else {
				$cols.=",";
				$values.=",";
			}
		}
		$cols.=")";
		$values.= ")";

		$query = "INSERT INTO " . $tableName . " " . $cols . " VALUES " . $values;
		$conn = self::connectToDb();
		$q = $conn->prepare($query);
		$q->execute($dataArray);
		return array('id' => $conn->lastInsertId(), 'creation_date' => date("Y-m-d H:i:s", time()));
	}

    private static function deleteFromDb($table , $whereCol , $whereVal){
        $conn = self::connectToDb();
        if($whereCol == null){
            $sql = "DELETE FROM ".$table;
            $q = $conn->query($sql);
            return $q;
        }else{
            $sql = "DELETE FROM ".$table." WHERE ".$whereCol."=".$whereVal;
            $q = $conn->query($sql);
            return $q;
        }


    }

    /* End Of Generic Section */

}

?>