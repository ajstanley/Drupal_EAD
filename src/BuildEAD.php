<?php
/**
 * Created by PhpStorm.
 * User: MacIntosh
 * Date: 2021-12-10
 * Time: 17:30
 */

namespace Drupal\ead;

use Drupal\file\Entity\File;
use Drupal\node\Entity\Node;

class BuildEAD {

  public static function buildNode($candidate, $member_of, &$context) {
    \Drupal::logger('agile EAD')->notice("Processing $candidate");
    $message = $candidate;
    $tmp = 'public://guides/tmp';
    $results = [];

      $source = "$tmp/$candidate";
      $dest = 'public://eads';
      $contents = \file_get_contents($source);
      $file_parts = [
        'filename' => $candidate,
        'uri' => "$dest/$candidate",
        'status' => 1,
      ];
      $ead_file = File::create($file_parts);
      $ead_file->save();
      $dir = dirname($ead_file->getFileUri());
      if (!file_exists($dir)) {
        mkdir($dir, 0770, TRUE);
      }
      \file_put_contents($ead_file->getFileUri(), $contents);
      $ead_file->save();
      $new_ead = Node::create(['type' => 'ead_finding_aid']);
      $new_ead->set('title', 'PlaceHolder');
      $new_ead->set('field_ead', $ead_file->id());
      $new_ead->set('field_member_of', $member_of);
      $new_ead->enforceIsNew();
      $results = $new_ead->save();

    $context['message'] = $message;
    $context['results'] = $results;
  }

  function EADFinishedCallback($success, $results, $operations) {
    if ($success) {
      $message = \Drupal::translation()->formatPlural(
        count($results),
        'One post processed.', '@count posts processed.'
      );
    }
    else {
      $message = t('Finished with an error.');
    }
    \Drupal::messenger()->addMessage($message);
  }

}
