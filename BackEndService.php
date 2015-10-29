<?php
/**
 * Created by IntelliJ IDEA.
 * User: etay
 * Date: 10/29/15
 * Time: 2:28 PM
 */
require_once 'db/manager.php';


if (($_POST) || (isset($_POST))) {
    $request = json_decode(file_get_contents("php://input"));
    switch ($request->action) {

        case "incNirCredit": $result = DbManager::incNirCredit();
                             echo json_encode($result);
                             exit;
    }

}